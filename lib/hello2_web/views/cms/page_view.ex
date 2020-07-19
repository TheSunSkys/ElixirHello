defmodule Hello2Web.CMS.PageView do
  use Hello2Web, :view
  alias Hello2.CMS

  def author_name(%CMS.Page{author: author}) do
    author.user.name
  end
end
