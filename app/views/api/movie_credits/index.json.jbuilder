@jobs.each do |job, participations|
  json.set! "#{job}" do
    json.array! participations, partial: 'api/participations/participation', as: :participation, key: :person
  end
end
