20.times do |i|
  User.create(email: "test_#{i}@test.com", password: 111111)
end

User.find_each do |u|
  SecureRandom.rand(5..10).times do
    u.posts.create(title: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4),
                   body: Faker::Lorem.paragraph(sentence_count: 10, supplemental: true, random_sentences_to_add: 10))
  end
end

User.find_each do |u|
  SecureRandom.rand(5..10).times do
    u.comments.create(body: Faker::Lorem.paragraph(sentence_count: 4, supplemental: true, random_sentences_to_add: 4),
                      target: User.order(Arel.sql('RANDOM()')).first)
  end

  SecureRandom.rand(5..10).times do
    u.comments.create(body: Faker::Lorem.paragraph(sentence_count: 4, supplemental: true, random_sentences_to_add: 4),
                      target: Post.order(Arel.sql('RANDOM()')).first)
  end
end

User.find_each do |u|
  SecureRandom.rand(5..10).times do
    u.comments.create(body: Faker::Lorem.paragraph(sentence_count: 4, supplemental: true, random_sentences_to_add: 4),
                      target: Comment.order(Arel.sql('RANDOM()')).first)
  end
end
