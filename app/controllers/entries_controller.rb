class EntriesController < ApplicationController
  def index
    matching_entries = Entry.all

    @list_of_entries = matching_entries.order({ :created_at => :desc })

    render({ :template => "entries/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_entries = Entry.where({ :id => the_id })

    @the_entry = matching_entries.at(0)

    render({ :template => "entries/show" })
  end

  def create
    the_entry = Entry.new
    the_entry.title = params.fetch("query_title")
    the_entry.body = params.fetch("query_body")

    ask = "Given sample titles like 'On Time', 'On Idea-Generation', and 'On AI and Writing', give me a concise title for the following text. Include only the title in your response, no punctuation or padding: " + params.fetch("query_body")
  
    ask2 = params.fetch("query_body")

    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"))

    messages = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You help rewrite journal entries to turn them from fragments into complete passages" },
          { role: "user", content: ask }
        ],
      }
    )

    response = messages.fetch("choices").at(0).fetch("message").fetch("content").to_s
    the_entry.title = response

    messages2 = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You help rewrite journal entries to turn them from fragments into complete passages. You are however very keen on preserving the voice and idiosyncracies of any text you come across." },
          { role: "user", content: ask2 }
        ],
      }
    )

    response2 = messages2.fetch("choices").at(0).fetch("message").fetch("content").to_s
    the_entry.body = response2

    if the_entry.valid?
      the_entry.save
      redirect_to("/entries", { :notice => "Entry created successfully." })
    else
      redirect_to("/entries", { :alert => the_entry.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_entry = Entry.where({ :id => the_id }).at(0)

    the_entry.title = params.fetch("query_title")
    the_entry.body = params.fetch("query_body")

    if the_entry.valid?
      the_entry.save
      redirect_to("/entries/#{the_entry.id}", { :notice => "Entry updated successfully."} )
    else
      redirect_to("/entries/#{the_entry.id}", { :alert => the_entry.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_entry = Entry.where({ :id => the_id }).at(0)

    the_entry.destroy

    redirect_to("/entries", { :notice => "Entry deleted successfully."} )
  end
end
