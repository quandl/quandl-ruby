require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe Quandl::ApiConfig do
  context '.api_base' do
    it 'defaults to Quandl' do
      expect(Quandl::ApiConfig.api_base).to eq('https://www.quandl.com/api/v3')
    end
  end

  context '.api_key' do
    it 'is nil by default' do
      expect(Quandl::ApiConfig.api_key).to be_nil
    end

    context 'threading' do
      let(:threads) { [] }

      before(:each) do
        Quandl::ApiConfig.reset
      end

      it 'should be nil if a default is not set' do
        1.times do
          threads << Thread.new do
            expect(Quandl::ApiConfig.api_key).to be_nil
          end
        end

        threads.map(&:join)
      end

      it 'allows users to change their settings per thread' do
        3.times do
          threads << Thread.new do
            api_key = (0...8).map { rand(65..90).chr }.join
            Quandl::ApiConfig.api_key = api_key
            expect(Quandl::ApiConfig.api_key).to eq(api_key)
          end
          sleep(1) # Important to ensure that previous thread code has executed
        end

        threads.map(&:join)
      end

      context 'with a default set' do
        let(:default_key) { (0...8).map { rand(65..90).chr }.join }

        before(:each) do
          Quandl::ApiConfig.api_key = default_key
        end

        it 'should allows for a default value' do
          # rubocop:disable Lint/AmbiguousBlockAssociation
          expect do
            3.times do
              threads << Thread.new do
                expect(Quandl::ApiConfig.api_key).to eq(default_key)

                api_key = (0...8).map { rand(65..90).chr }.join
                Quandl::ApiConfig.api_key = api_key
                expect(Quandl::ApiConfig.api_key).to eq(api_key)
              end
              sleep(1) # Important to ensure that previous thread code has executed
            end

            threads.map(&:join)
          end.not_to change {
            Quandl::ApiConfig.api_key
          }
          # rubocop:enable Lint/AmbiguousBlockAssociation
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
