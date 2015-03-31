part of dartup_server_test;

class MockDynamoDb extends Mock implements DynamoDb{
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockGitHub extends Mock implements GitHub{
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUsers extends Mock implements Users{
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}