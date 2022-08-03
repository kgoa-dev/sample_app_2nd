FactoryBot.define do
  factory :orange, class: Micropost do
    content { 'I just ate an orange!' }
    created_at { 10.minutes.ago }
  end

  factory :most_recent, class: Micropost do
    content { 'Writing a short test' }
    created_at { Time.zone.now }
    user { association :user, email: 'recent@example.com' }
  end

  factory :ants, class: Micropost do
    content { "Oh, is that what you want? Because that's how you get ants!" }
    created_at { 2.years.ago }
    user { association :archer, email: 'recent@example.com' }
  end

  factory :zone, class: Micropost do
    content { "Danger zone!" }
    created_at { 3.days.ago }
    user { association :archer, email: 'recent@example.com' }
  end

  factory :tone, class: Micropost do
    content { "I'm sorry. Your words made sense, but your sarcastic tone did not." }
    created_at { 10.minutes.ago }
    user { association :lana, email: 'recent@example.com' }
  end

  factory :van, class: Micropost do
    content { "Dude, this van's, like, rolling probable cause." }
    created_at { 4.hours.ago }
    user { association :lana, email: 'recent@example.com' }
  end

  factory :post_by_user, class: Micropost do
    content { 'Posted by User' }
    created_at { Time.zone.now }
    user
  end

  factory :post_by_archer, class: Micropost do
    content { 'Posted by Archer' }
    created_at { Time.zone.now }
    user factory: :archer
  end

  factory :post_by_lana, class: Micropost do
    content { 'Posted by Lana' }
    created_at { Time.zone.now }
    user factory: :lana
  end
end

def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:orange, posts_count, user: user)
  end
end
