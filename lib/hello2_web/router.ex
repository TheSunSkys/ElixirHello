defmodule Hello2Web.Router do
  use Hello2Web, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Hello2Web.Plugs.Locale, "en"
    # plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      user_id ->
        assign(conn, :current_user, Hello2.Accounts.get_user!(user_id))
    end
  end

  scope "/", Hello2Web do
    pipe_through :browser

    get "/", PageController, :index
    get "/redirect_test", PageController, :redirect_test
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
    # resources "/posts", PostController, only: [:index, :show]
    # resources "/users", UserController do
    #   resources "/posts", PostController
    # end

    # resources "/comments", CommentController, except: [:delete]

    # resources "/reviews", ReviewController
  end

  scope "/admin", Hello2Web.Admin, as: :admin do
    pipe_through :browser

    # resources "/images", ImageController
    # resources "/reviews", ReviewController
    # resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  scope "/api", Hello2Web.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      # resources "/images",  ImageController
      # resources "/reviews", ReviewController
      # resources "/users",   UserController
    end
  end

  scope "/cms", Hello2Web.CMS, as: :cms do
    pipe_through [:browser, :authenticate_user, :put_user_token]

    resources "/pages", PageController
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: Hello2Web.Telemetry
    end
  end
end
