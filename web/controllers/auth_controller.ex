defmodule OneHarmony.AuthController do
  use OneHarmony.Web, :controller

  @doc """
  This action is reached via `/auth` and redirects to the Google OAuth2
  """
  def index(conn, _params) do
    # https://www.googleapis.com/auth/userinfo.email
    url = Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/drive")
    # IO.puts url
    redirect conn, external: url
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  the Google OAuth2 will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
    # Retrieve access_token
    client = Google.get_token!(code: code)

    # IO.inspect client
    # IO.puts client.token.access_token
    # IO.puts " - - "
    # IO.puts client.token.refresh_token

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.

    user = get_user(client)
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> put_session(:refresh_token, client.token.refresh_token)
    |> redirect(to: "/")
  end

  @doc """
  Retrieve user data
  """
  defp get_user(client) do
    response = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    case response.status_code do
      200 -> response.body
      401 -> raise response.body
      _ -> raise response.body
     end
  end
end
