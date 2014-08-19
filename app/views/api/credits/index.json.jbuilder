@jobs.each do |job, participations|
  json.set! "#{job}s" do
    json.array! participations, partial: 'api/participations/participation', as: :participation, key: :movie
  end
end
