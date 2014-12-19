#!/usr/bin/env ruby
#

require 'rubygems'
require 'bundler'

Bundler.include

require 'sinatra'
require 'sinatra/partial'
require 'json'

require_relative 'logic/rest'

run REST


