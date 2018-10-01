require 'spec_helper'

describe 'vcommon::get_policy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'accepts parameters' do
        it { is_expected.to run.with_params('policy::testing') }
        it { is_expected.to run.with_params('policy::testing', 'default') }
      end

      context 'properly prefixes policy key' do
        it { is_expected.to run.with_params('policy::testing').and_return ('hiera') }
        it { is_expected.to run.with_params('::testing').and_return ('hiera') }
        it { is_expected.to run.with_params('testing').and_return ('hiera') }
      end

      context 'use provided default if it doesn\'t exist' do
        it { is_expected.to run.with_params('policy::nonexisting', 'defaults').and_return ('defaults') }
      end

      context 'return undef if no default specified' do
        it { is_expected.to run.with_params('policy::nonexisting').and_return (nil) }
      end

      context 'return found value when default value provided' do
        it { is_expected.to run.with_params('policy::testing', 'default').and_return ('hiera') }
      end
    end
  end
end
