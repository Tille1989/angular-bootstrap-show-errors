describe 'showErrors', ->
  $compile = undefined
  $scope = undefined

  beforeEach module('ui.bootstrap.showErrors')
  beforeEach inject((_$compile_, _$rootScope_) ->
    $compile = _$compile_
    $scope = _$rootScope_
  )

  describe 'directive does not contain an input element with a name attribute', ->
    it 'throws an exception', ->
      expect( ->
        $compile('<div class="form-group" show-errors><input type="text"></input></div>')($scope)
      ).toThrow "show-errors element has no child input elements with a 'name' attribute"

  it "throws an exception if the element doesn't have the form-group class", ->
    expect( ->
      $compile('<div show-errors></div>')($scope)
    ).toThrow "show-errors element does not have the 'form-group' class"

  it "throws an exception if the element isn't in a form tag", ->
    expect( ->
      $compile('<div class="form-group" show-errors><input type="text" name="firstName"></input></div>')($scope)
    ).toThrow()

  describe "when $pristine && $invalid", ->
    it "input element does not have the 'has-error' class", ->
      el = $compile('<form><div class="form-group" show-errors><input type="text" name="firstName"></input></div></form>')($scope)
      $scope.$digest()
      expect(el.find('div').hasClass('has-error')).toBe false

  describe 'when $dirty && $invalid', ->
    describe 'and blurred', ->
      it "input element does not have the 'has-error' class", ->
        el = $compile('<form name="userForm"><div class="form-group" show-errors><input type="text" name="firstName" ng-model="firstName" ng-minlength="3"></input></div></form>')($scope)
        $scope.$digest()
        $scope.userForm.firstName.$setViewValue 'Pa'
        el.find('input')[0].dispatchEvent new Event('blur')
        expect(el.find('div').hasClass('has-error')).toBe true

    describe 'and not blurred', ->
      it "input element does not have the 'has-error' class", ->
        el = $compile('<form name="userForm"><div class="form-group" show-errors><input type="text" name="firstName" ng-model="firstName" ng-minlength="3"></input></div></form>')($scope)
        $scope.$digest()
        $scope.userForm.firstName.$setViewValue 'Pa'
        el.find('input')[0].dispatchEvent new Event('change')
        expect(el.find('div').hasClass('has-error')).toBe false
