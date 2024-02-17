# spec/fabricators/course_fabricator.rb
Fabricator(:course) do
  name { Faker::Educator.course_name }
end
