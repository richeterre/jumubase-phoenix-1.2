defmodule Jumubase.Internal.CategoryController do
  use Jumubase.Web, :controller
  alias Jumubase.{Endpoint, Category}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Categories"), url: internal_category_path(Endpoint, :index)

  plug :authorize_action, resource: Category

  def index(conn, _params) do
    conn
    |> assign(:categories, Repo.all(from h in Category, order_by: h.name))
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Category.changeset(%Category{}))
    |> add_breadcrumb(icon: "plus", url: internal_category_path(Endpoint, :new))
    |> render("new.html")
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)
    case Repo.insert(changeset) do
      {:ok, category} ->
        conn
        |> put_flash(:success,
          gettext("The category \"%{name}\" was created.", name: category.name))
        |> redirect(to: internal_category_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
