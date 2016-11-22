require 'spec_helper'

feature 'data catalog management' do
  let(:organization) { FactoryGirl.create(:organization) }

  scenario 'can consume published catalog data' do
    catalog = create(:catalog, organization: organization)
    dataset = create(:dataset, catalog: catalog)
    distribution = create(:distribution, dataset: dataset)
    distribution.update_column(:state, 'published')

    get "/#{organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    expect(json_response['title']).to eql("Catálogo de datos abiertos de #{organization.title}")
    expect(json_response['dataset']).not_to be_empty
  end

  scenario 'can\'t consume unpublished catalog data' do
    create(:catalog, :unpublished, organization: organization)

    get "/#{organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    expect(json_response).to eql({})
  end

  scenario 'can see all the catalogs available through the api' do
    catalog = create(:catalog, :datasets)
    dataset = create(:dataset, catalog: catalog)
    distribution = create(:distribution, dataset: dataset)
    distribution.update_column(:state, 'published')

    get '/api/v1/organizations/catalogs.json'
    json_response = JSON.parse(response.body)
    expect(json_response.size).to eq(1)
  end

  scenario 'catalog will have correct DCAT key names' do
    catalog = create(:catalog, organization: organization)
    dataset = create(:dataset, catalog: catalog)
    distribution = create(:distribution, dataset: dataset)
    distribution.update_column(:state, 'published')

    dcat_keys = %w(title description homepage issued modified language license dataset)
    dcat_dataset_keys = %w(id title description issued modified identifier keyword language contactPoint temporal spatial accrualPeriodicity landingPage publisher public publishDate distribution openessRating govType theme comments)
    dcat_distribution_keys = %w(id title description issued modified license downloadURL mediaType format byteSize temporal spatial publishDate)

    get "/#{organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    expect(json_response.keys).to eq(dcat_keys)
    expect(json_response['dataset'].last.keys.sort).to eq(dcat_dataset_keys.sort)
    expect(json_response['dataset'].last['distribution'].last.keys.sort).to eq(dcat_distribution_keys.sort)
  end

  scenario 'removes linebreaks from keywods' do
    catalog = create(:catalog, organization: organization)
    dataset = create(:dataset, catalog: catalog, keyword: "foo\n, bar\r\n")
    distribution = create(:distribution, dataset: dataset)
    distribution.update_column(:state, 'published')

    get "/#{organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    json_response['dataset'][0]['keyword'].sort == %w(bar foo)
  end

  scenario 'dataset keywords contain the organization gov_type' do
    organization = create(:organization, :federal)
    catalog = create(:catalog, organization: organization)
    dataset = create(:dataset, catalog: catalog)
    distribution = create(:distribution, dataset: dataset)
    distribution.update_column(:state, 'published')

    get "/#{organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    expect(json_response['dataset'][0]['keyword']).to include('federal')
  end
end
