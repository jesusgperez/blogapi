class PostsSearchService
    def self.search(posts, query)
        posts.where("title like '%#{query}%'")
    end
end