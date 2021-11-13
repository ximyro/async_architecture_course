module Web
  module Controllers
    module Home
      class Index
        include Web::Action
        expose :title

        def call(params)
          @title = "Home"
        end
      end
    end
  end
end
