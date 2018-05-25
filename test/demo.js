'use strict';

require('mocha');
var assert = require('assert');
var gitLog = require('../src');

describe('git-log', function () {
  it('should return the username from a git remote origin url', function () {
    assert.equal(username(), 'jonschlinkert');
    assert.equal(username('.git'), 'jonschlinkert');
    assert.equal(username('.git/config'), 'jonschlinkert');
  });

  it('should return throw an error when not found and options.strict is true', function () {
    assert.throws(function () {
      username('foo', { strict: true });
    }, /cannot resolve/);

    assert.throws(function () {
      username('bar/baz', { strict: true });
    }, /cannot resolve/);
  });
});