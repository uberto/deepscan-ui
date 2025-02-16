scope "/", YourAppWeb do
  pipe_through :browser
  
  live "/pdf/view/:id", PdfViewerLive
end 