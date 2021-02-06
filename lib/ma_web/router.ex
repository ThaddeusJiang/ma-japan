defmodule MaWeb.Router do
  use MaWeb, :router
  use Pow.Phoenix.Router

  import MaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :landing do
    plug :put_layout, {MaWeb.LayoutView, :landing}
  end

  pipeline :admin do
    plug MaWeb.EnsureRolePlug, :admin
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", MaWeb do
    pipe_through [:browser, :landing]

    get "/", LandingController, :index
  end

  scope "/", MaWeb do
    pipe_through [:browser]

    get "/blogs", BlogController, :index
    get "/blogs/:id", BlogController, :show

    get "/businesses", ProductController, :index
    get "/businesses/:id", ProductController, :show

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm

    # static
    get "/about", StaticController, :about, as: :my_static
    get "/price", StaticController, :price, as: :my_static
    get "/terms", StaticController, :terms, as: :my_static
  end

  ## Authentication routes
  scope "/", MaWeb do
    # 如果登录了，跳转到 /

    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/log_in", UserSessionController, :new
    post "/log_in", UserSessionController, :create
    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", MaWeb do
    # 如果未登录，跳转到 /login
    pipe_through [:browser, :require_authenticated_user]

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    get "/settings/confirm_email/:token", UserSettingsController, :confirm_email
    # 付款
    get "/settings/billing/checkout", BillingController, :new
    get "/settings/billing/checkout/success", BillingController, :success
    get "/settings/billing/checkout/failure", BillingController, :failure
    # 管理订阅
    get "/settings/billing", UserSettingsController, :billing
    post "/settings/billing", UserSettingsController, :manage
  end

  scope "/admin", MaWeb do
    # 管理员
    pipe_through [:browser, :require_authenticated_user, :admin]

    live "/businesses", BusinessLive.Index, :index
    live "/businesses/new", BusinessLive.Index, :new
    live "/businesses/:id/edit", BusinessLive.Index, :edit

    live "/businesses/:id", BusinessLive.Show, :show
    live "/businesses/:id/show/edit", BusinessLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MaWeb do
  #   pipe_through :api
  # end

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
      live_dashboard "/dashboard", metrics: MaWeb.Telemetry
    end
  end
end
