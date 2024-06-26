defmodule ExqUIWeb.DeadLive.IndexTest do
  use ExqUI.ConnCase

  test "/dead", %{conn: conn} do
    {:ok, view, _} = live(conn, "/dead")
    html = render(view)

    assert html =~ ~r/hard.*409.*RuntimeError/s
    assert html =~ ~r/hard.*548.*kill/s
  end

  test "view and delete single job", %{conn: conn} do
    {:ok, view, _} = live(conn, "/dead")

    {:ok, view, _} =
      element(view, "#dead-table > tbody > tr:nth-child(1) > td:nth-child(2) > a")
      |> render_click()
      |> follow_redirect(conn)

    html = render(view)
    assert html =~ ~r/JID.*b8f7d783-7993-4759-a866-fc4af5db8e1f/

    {:ok, view, _} =
      element(view, "div.col-4.my-2 > a", "Delete")
      |> render_click()
      |> follow_redirect(conn)

    html = render(view)
    refute html =~ ~r/hard.*409.*RuntimeError/s
    assert html =~ ~r/hard.*548.*kill/s
  end

  test "retry now", %{conn: conn} do
    {:ok, view, _} = live(conn, "/dead")

    {:ok, view, _} =
      element(view, "#dead-table > tbody > tr:nth-child(1) > td:nth-child(2) > a")
      |> render_click()
      |> follow_redirect(conn)

    html = render(view)
    assert html =~ ~r/JID.*b8f7d783-7993-4759-a866-fc4af5db8e1f/

    {:ok, view, _} =
      element(view, "div.col-4.my-2 > a:nth-child(2)", "Retry Now")
      |> render_click()
      |> follow_redirect(conn)

    html = render(view)
    refute html =~ ~r/hard.*409.*RuntimeError/s
    assert html =~ ~r/hard.*548.*kill/s

    {:ok, view, _} = live(conn, "/queues/hard")
    html = render(view)
    assert html =~ ~r/Hardworker.*409/s
  end

  test "delete_all", %{conn: conn} do
    {:ok, view, _} = live(conn, "/dead")
    html = render(view)
    assert html =~ ~r/hard.*409.*RuntimeError/s
    assert html =~ ~r/hard.*548.*kill/s

    element(
      view,
      "#table-component"
    )
    |> render_hook("action", %{"table" => %{"action" => "delete_all"}})

    {:ok, view, _} = live(conn, "/dead")
    html = render(view)
    refute html =~ ~r/hard.*409.*RuntimeError/
    refute html =~ ~r/hard.*548.*kill/
  end
end
