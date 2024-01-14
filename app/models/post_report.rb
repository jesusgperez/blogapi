class PostReport < Struct.new(:word_count, :word_histogram)
  def self.generate(post)
    PostReport.new(
      # word count
      post.content.split.map { |word| word.gsub(/\W/, '') }.count,
      # word histogram
      create_histogram(post)
    )
  end

  private

  def self.create_histogram(post)
    (post
      .content
      .split
      .map { |word| word.gsub(/\W/, '') }
      .map(&:downcase)
      .group_by { |word| word }
      .transform_values(&:size)
    )
  end
end