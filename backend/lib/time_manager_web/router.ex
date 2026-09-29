defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

     resources "/users", UserController, except: [:new, :edit]
       
  end
scope "/api/workingtime", TimeManagerWeb do
  pipe_through :api

  get "/:userID", WorkingTimeController, :index_by_user
  get "/:userID/:id", WorkingTimeController, :show_by_user
  post "/:userID", WorkingTimeController, :create_for_user
  put "/:id", WorkingTimeController, :update
  delete "/:id", WorkingTimeController, :delete
end
scope "/api/clocks", TimeManagerWeb do
  pipe_through :api

  get "/:userID", ClockController, :index_by_user
  post "/:userID", ClockController, :toggle
end
  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
