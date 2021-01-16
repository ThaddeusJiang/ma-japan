defmodule Ma.Email do
  import Bamboo.Email

  def welcome_email(to, body) do
    base_email()
    |> to(to)
    |> subject("Welcome!!!")
    |> html_body("<strong><pre>#{body}</pre></strong>")
    |> text_body("#{body}")
  end

  defp base_email do
    new_email()
    |> from("thaddeusjiang@gmail.com")
  end
end
