Rails.application.routes.draw do
  get("/", { :controller => "entries", :action => "index" })
  # Routes for the Entry resource:

  # CREATE
  post("/insert_entry", { :controller => "entries", :action => "create" })
          
  # READ
  get("/entries", { :controller => "entries", :action => "index" })
  
  get("/entries/:path_id", { :controller => "entries", :action => "show" })
  
  # UPDATE
  
  post("/modify_entry/:path_id", { :controller => "entries", :action => "update" })
  
  # DELETE
  get("/delete_entry/:path_id", { :controller => "entries", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
