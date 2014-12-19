#!/usr/bin/env ruby
#

require 'rubygems'
require 'json'
require 'bundler'

Bundler.require

require 'sinatra'
require 'sinatra/partial'
#require 'nokogiri'

require_relative 'logic/app'

run App


