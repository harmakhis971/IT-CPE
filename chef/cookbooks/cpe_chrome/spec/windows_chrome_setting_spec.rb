#
# Cookbook Name:: cpe_browsers
# Spec:: windows_chrome_setting
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# Copyright (c) 2016-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.
#

require_relative 'spec_helper'

RSpec.describe WindowsChromeSetting do
  settings = {
    'empty_setting' =>
      { 'ExtensionInstallBlacklist' => [] },
    'example_setting' => {
      'ExtensionInstallForcelist' =>
      ['ncfpggehkhmjpdjpefomjchjafhmbnai;bacon'],
    },
    'doc_setting' =>
      { 'AlternateErrorPagesEnabled' => [true] },
  }

  expected_results = {
    'empty_setting' => {
      'header' => 'A simple setting that has no value',
      'name' => 'ExtensionInstallBlacklist',
      'type' => :string,
      'data' => [],
      'expected_class' => 'Array',
      'fullpath' => 'HKLM\Software\Policies\Google\Chrome' +
                '\ExtensionInstallBlacklist',
      'fullpath_forced' =>
        'HKLM\Software\Policies\Google\Chrome' +
        '\ExtensionInstallBlacklist',
      'path' => 'HKLM\Software\Policies\Google\Chrome',
    },
    'example_setting' => {
      'header' =>
        'A simple setting I arbitrarily grabbed from the attributes ' +
        'file',
      'name' => 'ExtensionInstallForcelist',
      'type' => :string,
      'data' => ['ncfpggehkhmjpdjpefomjchjafhmbnai;bacon'],
      'expected_class' => 'Array',
      'fullpath' => 'HKLM\Software\Policies\Google\Chrome' +
                '\ExtensionInstallForcelist',
      'fullpath_forced' =>
        'HKLM\Software\Policies\Google\Chrome' +
        '\ExtensionInstallForcelist',
      'path' => 'HKLM\Software\Policies\Google\Chrome',
    },
    'doc_setting' => {
      'header' => 'A more complex setting I grabbed from the Chrome ' +
        'documentation',
      'name' => 'AlternateErrorPagesEnabled',
      'type' => :dword,
      'data' => [true],
      'expected_class' => 'Array',
      'fullpath' => 'HKLM\Software\Policies\Google\Chrome' +
                '\AlternateErrorPagesEnabled',
      'fullpath_forced' =>
        'HKLM\Software\Policies\Google\Chrome' +
        '\AlternateErrorPagesEnabled',
      'path' => 'HKLM\Software\Policies\Google\Chrome',
    },
  }

  shared_examples 'the chrome setting creates the key in HKLM' do
    context 'setting is forced' do
      let(:result) do
        'HKLM\\Software\\Policies\\Google\\Chrome' +
        '\ExtensionInstallForcelist'
      end
      subject do
        WindowsChromeSetting.new(settings['example_setting'], true)
      end
      it { should eq result }
    end
    context 'setting is not forced' do
      let(:result) do
        'HKLM\\Software\\Policies\\Google\\Chrome' +
        '\ExtensionInstallForcelist'
      end
      subject do
        WindowsChromeSetting.new(settings['example_setting'], false)
      end
      it { should eq result }
    end
  end
  context 'A simple setting that has no value' do
    context 'its data' do
      subject { WindowsChromeSetting.new(settings['empty_setting']).data }
      it { should be_a Array }
      it { should eql [] }
    end
    context 'is the setting marked as empty?' do
      subject { WindowsChromeSetting.new(settings['empty_setting']).empty? }
      it { should be true }
    end
  end
  settings.each_key do |setting|
    context expected_results['header'] do
      context 'registry key name' do
        subject { WindowsChromeSetting.new(settings[setting]).name }
        it { should eq expected_results[setting]['name'] }
      end
      context 'registry key path' do
        subject { WindowsChromeSetting.new(settings[setting]).path }
        it { should eq expected_results[setting]['path'] }
      end
      context 'registry key fullpath' do
        subject { WindowsChromeSetting.new(settings[setting]).fullpath }
        it { should eq expected_results[setting]['fullpath'] }
      end
      context 'registry key fullpath forced' do
        subject { WindowsChromeSetting.new(settings[setting], true).fullpath }
        it { should eq expected_results[setting]['fullpath_forced'] }
      end
      context 'registry key type' do
        subject { WindowsChromeSetting.new(settings[setting]).type }
        it { should eq expected_results[setting]['type'] }
      end
      context 'registry key data' do
        subject { WindowsChromeSetting.new(settings[setting]).data }
        it { should eq expected_results[setting]['data'] }
        it do
          should be_a Kernel.
            const_get(expected_results[setting]['expected_class'])
        end
      end
    end
  end
end
