shared_context 'MX stock location' do
  let!(:stock_location) do
    create :stock_location,
      address1: '1600 Pennsylvania Ave NW',
      address2: '1600 Pennsylvania Ave NW',
      address3: '1600 Pennsylvania Ave NW',
      city: 'Ciudad de Mexico',
      zipcode: '06700',
      state: create(:state_with_autodiscover, state_code: 'DF')
  end
end
