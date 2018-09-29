require 'spec_helper'

describe 'v_ensure_packages' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'using a string package name' do
        it {
          is_expected.to run.with_params('foo')
          expect(catalogue).to contain_package('foo').with_ensure('latest')
        }

        it 'merges options correctly' do
          is_expected.to run.with_params('foo', { 'provider' => 'defaults', 'vendor' => 'defaults'})
          expect(catalogue).to contain_package('foo').with(
            'provider' => 'defaults',
            'vendor' => 'defaults'
          )
        end

        it 'doesn\'t override provided defaults' do
          is_expected.to run.with_params('foo', {'ensure' => 'defaults', 'provider' => 'defaults'})
          expect(catalogue).to contain_package('foo').with(
            'ensure' => 'defaults',
            'provider' => 'defaults'
          )
        end
      end

      context 'using array of packages' do
        it {
          is_expected.to run.with_params(['foo', 'bar'])
          expect(catalogue).to contain_package('foo').with_ensure('latest')
          expect(catalogue).to contain_package('bar').with_ensure('latest')
        }

        it 'merges options correctly' do
          is_expected.to run.with_params(['foo', 'bar'], { 'provider' => 'defaults', 'vendor' => 'defaults'})
          expect(catalogue).to contain_package('foo').with(
            'provider' => 'defaults',
            'vendor' => 'defaults'
          )
          expect(catalogue).to contain_package('bar').with(
            'provider' => 'defaults',
            'vendor' => 'defaults'
          )
        end

        it 'doesn\'t override provided defaults' do
          is_expected.to run.with_params(['foo', 'bar'], {'ensure' => 'defaults', 'provider' => 'defaults'})
          expect(catalogue).to contain_package('foo').with(
            'ensure' => 'defaults',
            'provider' => 'defaults'
          )

          expect(catalogue).to contain_package('bar').with(
            'ensure' => 'defaults',
            'provider' => 'defaults'
          )
        end
      end

      context 'using hash of packages' do
        it {
          is_expected.to run.with_params({'foo' => {}, 'bar' => {}})
          expect(catalogue).to contain_package('foo').with_ensure('latest')
          expect(catalogue).to contain_package('bar').with_ensure('latest')
        }

        it 'doesn\'t override package defaults' do
          is_expected.to run.with_params({'foo' => {'ensure' => 'package', 'provider' => 'package'}, 'bar' => { 'provider' => 'package' }})
          expect(catalogue).to contain_package('foo').with('ensure' => 'package', 'provider' => 'package')
          expect(catalogue).to contain_package('bar').with('ensure' => 'latest', 'provider' => 'package')
        end

        it 'merges options correctly' do
          is_expected.to run.with_params({
              'foo' => { 'ensure' => 'package', 'provider' => 'package' },
              'bar' => { 'provider' => 'package', 'vendor' => 'package' }
            },
            { 'vendor' => 'defaults', 'source' => 'defaults' })

          expect(catalogue).to contain_package('foo').with(
            'ensure' => 'package',
            'provider' => 'package',
            'vendor' => 'defaults',
            'source' => 'defaults'
          )
          expect(catalogue).to contain_package('bar').with(
            'ensure' => 'latest',
            'provider' => 'package',
            'vendor' => 'package',
            'source' => 'defaults'
          )
        end
      end
    end
  end
end
