defmodule Jumubase.Internal.CategoryController do
  use Jumubase.Web, :controller
  use Jumubase.Internal.Controller
  alias Jumubase.{Endpoint, Category}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Categories"), url: internal_category_path(Endpoint, :index)

  def index(conn, _params, user) do
    case Permit.authorize(Category, :index, user) do
      :ok ->
        conn
        |> assign(:categories, Repo.all(from h in Category, order_by: h.name))
        |> render("index.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def new(conn, _params, user) do
    case Permit.authorize(Category, :new, user) do
      :ok ->
        conn
        |> assign(:changeset, Category.changeset(%Category{}))
        |> add_breadcrumb(icon: "plus", url: internal_category_path(Endpoint, :new))
        |> render("new.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def create(conn, %{"category" => category_params}, user) do
    changeset = Category.changeset(%Category{}, category_params)
    with :ok <- Permit.authorize(Category, :create, user),
      {:ok, category} <- Repo.insert(changeset)
    do
      conn
        |> put_flash(:success,
          gettext("The category \"%{name}\" was created.", name: category.name))
        |> redirect(to: internal_category_path(conn, :index))
    else
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
