defmodule YourAppWeb.PdfViewerLive do
  use YourAppWeb, :live_view
  alias YourApp.PdfProcessor

  @impl true
  def mount(%{"id" => pdf_id} = params, _session, socket) do
    page = String.to_integer(Map.get(params, "page", "1"))
    
    with {:ok, total_pages} <- PdfProcessor.get_total_pages(pdf_id),
         {:ok, image_path} <- PdfProcessor.get_page_image(pdf_id, page) do
      {:ok,
       assign(socket,
         pdf_id: pdf_id,
         current_page: page,
         total_pages: total_pages,
         image_path: image_path
       )}
    else
      _ -> {:ok, assign(socket, error: "PDF not found or invalid")}
    end
  end

  @impl true
  def handle_event("change_page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    
    if page >= 1 and page <= socket.assigns.total_pages do
      {:ok, image_path} = PdfProcessor.get_page_image(socket.assigns.pdf_id, page)
      
      {:noreply,
       socket
       |> assign(current_page: page, image_path: image_path)
       |> push_patch(to: ~p"/pdf/view/#{socket.assigns.pdf_id}?page=#{page}")}
    else
      {:noreply, socket}
    end
  end
end 