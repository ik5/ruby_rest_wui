#!/usr/bin/env ruby
#

require 'rubygems'
require 'bundler'

Bundler.include

require 'sinatra'
require 'sinatra/partial'

require_relative 'logic/rest'

run REST


