defmodule OneHarmony.PageController do
  use OneHarmony.Web, :controller

  def index(conn, _params) do
    user = get_session(conn, :current_user)
    token = get_session(conn, :access_token)
    files = get_files(user, token)
    # IO.inspect files["files"]
    render conn, "index.html", files: files["files"]
  end

  defp get_files(user, token) do
    # Load files from Drive using Drive API
    case user do
      %{} ->
        client = Google.client_with_token(token)
        files = OAuth2.Client.get!(client, "https://www.googleapis.com/drive/v3/files").body
      _ -> []
    end
  end
end
