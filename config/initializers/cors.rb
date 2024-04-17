Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:5173'
      resource '*', 
        headers: :any, 
        methods: [:get, :post, :put, :patch, :delete, :options, :head, :options],
        credentials: true
    end
  
    # Deployment URL or domain
    # allow do
    #   origins 'http://localhost:5173'
    #   resource '*', 
    #     headers: :any, 
    #     methods: [:get, :post, :put, :patch, :delete, :options, :head, :options],
    #     credentials: true
    # end
    allow do
      origins "*"
  
      resource "*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  
  end
  