module ElasticSearchHelper
  def search_users(query)
    return [] if query.blank? # Trả về mảng rỗng nếu không có query

    puts "ElasticSearch Query Executing..."

    search_query = {
      query: {
        script_score: {
          query: {
            bool: {
              should: [
                { match: { name: { query: query, fuzziness: "AUTO" } } },  # fuzzzinenss là chọn kiểu gần đúng 
                { match: { email: { query: query, fuzziness: "AUTO" } } }
              ],
              minimum_should_match: 1
            }
          },
          script: {
            source: <<~Painless
              double score = 1.0;
              if (doc['followers_count'].size() > 0) {
                score += doc['followers_count'].value * 0.1;
              }
              return score;
            Painless
          }
        }
      }
    }

    users = User.__elasticsearch__.search(search_query)
   
    return users.response["hits"]["hits"].map { |hit| hit["_source"] } # Trả về danh sách user
  end
  
end
