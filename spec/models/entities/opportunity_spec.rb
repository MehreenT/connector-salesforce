require 'spec_helper'

describe Entities::Opportunity do

  before { allow(Maestrano::Connector::Rails::External).to receive(:timezone).and_return('UTC') }

  describe 'class methods' do
    subject { Entities::Opportunity }

    it { expect(subject.connec_entity_name).to eql('Opportunity') }
    it { expect(subject.external_entity_name).to eql('Opportunity') }
    it { expect(subject.currency_check_fields).to eql(%w(amount)) }
    it { expect(subject.object_name_from_connec_entity_hash({'name' => 'Mno'})).to eql('Mno') }
    it { expect(subject.object_name_from_external_entity_hash({'Name' => 'Mno'})).to eql('Mno') }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    subject { Entities::Opportunity.new(organization, nil, nil, {}) }

    describe 'SalesForce to connec!' do
      let(:sf) {
        {
          "attributes"  =>  {
            "type"    =>"Opportunity",
            "url"    =>"/services/data/v32.0/sobjects/Opportunity/00628000006HPkiAAG"
          },
          "Id"  =>"00628000006HPkiAAG",
          "IsDeleted"  =>false,
          "AccountId"  =>"0012800000C3cS9AAJ",
          "IsPrivate"  =>false,
          "Name"  =>"GenePoint Lab Generators",
          "Description"  =>nil,
          "StageName"  =>"Id. Decision Makers",
          "Amount"  =>60000.0,
          "Probability"  =>60.0,
          "ExpectedRevenue"  =>36000.0,
          "TotalOpportunityQuantity"  =>nil,
          "CloseDate"  =>"2013-11-07",
          "Type"  =>nil,
          "NextStep"  =>nil,
          "LeadSource"  =>nil,
          "IsClosed"  =>false,
          "IsWon"  =>false,
          "ForecastCategory"  =>"Pipeline",
          "ForecastCategoryName"  =>"Pipeline",
          "CampaignId"  =>nil,
          "HasOpportunityLineItem"  =>false,
          "Pricebook2Id"  =>nil,
          "OwnerId"  =>"00528000001eP9OAAU",
          "CreatedDate"  =>"2015-11-29T15:24:02.000+0000  ",
          "CreatedById"=>"00528000001eP9OAAU",
          "LastModifiedDate"  =>"2015-12-05T14:22:27.000+0000  ",
          "LastModifiedById"=>"00528000001eP9OAAU",
          "SystemModstamp"  =>"2015-12-05T14:22:27.000+0000  ",
          "LastActivityDate"=>nil,
          "FiscalQuarter"  =>4,
          "FiscalYear"  =>2013,
          "Fiscal"  =>"2013 4",
          "LastViewedDate"  =>"2015-12-05T14:22:27.000+0000  ",
          "LastReferencedDate"=>"2015-12-05T14:22:27.000+0000  ",
          "DeliveryInstallationStatus__c"=>"Yet to begin",
          "TrackingNumber__c"  =>nil,
          "OrderNumber__c"  =>nil,
          "CurrentGenerators__c"  =>"Hawkpower, Fujitsu",
          "MainCompetitors__c"  =>"Hawkpower"
        }
      }

      let (:mapped_sf) {
        {
          :opts => {
            :attached_to_org => "0012800000C3cS9AAJ"
          },
          :id => [{:id=>"00628000006HPkiAAG", :provider=>organization.oauth_provider, :realm=>organization.oauth_uid}],
          :amount=>{:total_amount=>60000.0},
          :expected_close_date=>'2013-11-07T23:59:59Z',
          :name=>"GenePoint Lab Generators",
          :probability=>60.0,
          :sales_stage=>"Id. Decision Makers",
          :assignee_id => [{"id"=>"00528000001eP9OAAU", "provider"=>organization.oauth_provider, "realm"=>organization.oauth_uid}],
          :assignee_type => "Entity::AppUser",
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(sf)).to eql(mapped_sf) }
    end

    describe 'connec to salesforce' do
      let(:connec) {
        {
          "id"  =>"2c3d1121-7d87-0133-9e73-0620e3ce3a45",
          "code"  =>"POT1",
          "name"  =>"Test",
          "description"  =>"",
          "sales_stage"  =>"Prospecting",
          "type"  =>"",
          "expected_close_date"  =>"2015-12-15T23:00:00Z",
          "amount"  =>  {
            "total_amount"    =>0.0
          },
          "probability"  =>23.0,
          "next_step"  =>"",
          "sales_stage_changes"  =>  [
            {
              "status"      =>"Prospecting",
              "created_at"      =>"2015-12-05T14:05:32Z"
            }
          ],
          "assignee_id"  =>"20715521-7cd5-0133-db80-0620e3ce3a45",
          "assignee_type"  =>"Entity::AppUser",
          "created_at"  =>"2015-12-05T14:05:32Z",
          "updated_at"  =>"2015-12-05T14:23:10Z",
          "group_id"  =>"cld-94m8",
          "channel_id"  =>"org-fg5b",
          "resource_type"  =>"opportunities"
        }
      }

      let(:mapped_connec) {
        {
          :Amount=>0.0,
          :CloseDate=>"2015-12-15",
          :Description=>"",
          :NextStep=>"",
          :OwnerId=>"20715521-7cd5-0133-db80-0620e3ce3a45",
          :Name=>"Test",
          :Probability=>23.0,
          :StageName=>"Prospecting",
          :Type=>"",
          :AccountId=>'abc'
        }.with_indifferent_access
      }

      before { allow(Entities::Opportunity).to receive(:get_org_id) { 'abc' } }
      it { expect(subject.map_to_external(connec)).to eql(mapped_connec) }
    end
  end
end
