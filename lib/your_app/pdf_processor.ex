defmodule YourApp.PdfProcessor do
  @pdf_dir "priv/static/pdfs"
  @image_dir "priv/static/pdf_images"

  def get_total_pages(pdf_id) do
    pdf_path = Path.join(@pdf_dir, "#{pdf_id}.pdf")
    
    case File.exists?(pdf_path) do
      true ->
        {:ok, PDF2Image.pages_count(pdf_path)}
      false ->
        {:error, :not_found}
    end
  end

  def get_page_image(pdf_id, page) do
    pdf_path = Path.join(@pdf_dir, "#{pdf_id}.pdf")
    image_filename = "#{pdf_id}_#{page}.png"
    image_path = Path.join(@image_dir, image_filename)
    
    if File.exists?(image_path) do
      {:ok, "/pdf_images/#{image_filename}"}
    else
      case generate_page_image(pdf_path, page, image_path) do
        :ok -> {:ok, "/pdf_images/#{image_filename}"}
        error -> error
      end
    end
  end

  defp generate_page_image(pdf_path, page, output_path) do
    File.mkdir_p!(Path.dirname(output_path))
    
    case PDF2Image.pdf_to_image(pdf_path, page: page, output: output_path) do
      {:ok, _} -> :ok
      error -> error
    end
  end
end 