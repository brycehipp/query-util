component extends="testbox.system.BaseSpec"{

  function run() {

    describe('QueryUtil', function() {
      var util = getMockBox().createMock('root.models.QueryUtil');
      var mockQuery = getMockBox().querySim('col1,col2,col3,col10
      1 | 1 | 1 | 1
      2 | 2 | 2 | 2
      3 | 3 | 3 | 3
      4 | 4 | 4 | 4
      5 | 5 | 5 | 5
      6 | 6 | 6 | 6');

      describe('splice', function() {
        it('should not alter column order', function() {
          var queryUnderTest = util.splice(mockQuery, 1, 2);
          expect(queryUnderTest.getColumnNames()).toBe(['col1', 'col2', 'col3', 'col10']);;
        });

        it('should not splice any rows if count is 0', function() {
          var queryUnderTest = util.splice(mockQuery, 1, 0);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(mockQuery.recordCount)
            .toBe(mockQuery);
        });

        it('should remove all subsequent rows if count is too large', function() {
          var assertionMockQuery = getMockBox().querySim('col1,col2,col3,col10
          1 | 1 | 1 | 1
          2 | 2 | 2 | 2');
          var queryUnderTest = util.splice(mockQuery, 3, mockQuery.recordCount + 1);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(2)
            .toBe(assertionMockQuery);
        });

        it('should remove a 2 rows if provided count 2', function() {
          var assertionMockQuery = getMockBox().querySim('col1,col2,col3,col10
          3 | 3 | 3 | 3
          4 | 4 | 4 | 4
          5 | 5 | 5 | 5
          6 | 6 | 6 | 6');
          var queryUnderTest = util.splice(mockQuery, 1, 2);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(mockQuery.recordCount - 2)
            .toBe(assertionMockQuery);
        });

        it('should remove all rows if count is greater than or equal to the record count', function() {
          var queryUnderTest = util.splice(mockQuery, 1, mockQuery.recordCount + 1);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(0)
            .toBeEmpty();

          queryUnderTest = util.splice(mockQuery, 1, mockQuery.recordCount);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(0)
            .toBeEmpty();
        });

      });

      describe('slice', function() {
        it('should not alter column order', function() {
          var queryUnderTest = util.slice(mockQuery, 1, 2);
          expect(queryUnderTest.getColumnNames()).toBe(['col1', 'col2', 'col3', 'col10']);;
        });

        it('should return the entire query if end is 0', function() {
          var queryUnderTest = util.slice(mockQuery, 1, 0);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(mockQuery.recordCount);
        });

        it('should return the original query if begin is 1 and end is greater than or equal to the record count', function() {
          var queryUnderTest = util.slice(mockQuery, 1, mockQuery.recordCount + 1);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(mockQuery.recordCount)
            .toBe(mockQuery);
        });

        it('should return from start to the end if end is greater than record count', function() {
          var assertionMockQuery = getMockBox().querySim('col1,col2,col3,col10
          3 | 3 | 3 | 3
          4 | 4 | 4 | 4
          5 | 5 | 5 | 5
          6 | 6 | 6 | 6');
          var queryUnderTest = util.slice(mockQuery, 3, mockQuery.recordCount + 1);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(mockQuery.recordCount - 2)
            .toBe(assertionMockQuery);
        });

        it('should create a query with a single record if end is 1', function() {
          var queryUnderTest = util.slice(mockQuery, 1, 1);
          expect(queryUnderTest)
          .toBeQuery()
          .toHaveLength(1);
        });

        it('should create a query with a single record if end is 2', function() {
          var queryUnderTest = util.slice(mockQuery, 1, 2);
          expect(queryUnderTest)
          .toBeQuery()
          .toHaveLength(1);
        });

        it('should return the query if end is greater than the record count', function() {
          var queryUnderTest = util.slice(mockQuery, 1, mockQuery.recordCount + 1);
          expect(queryUnderTest)
            .toBeQuery()
            .toHaveLength(mockQuery.recordCount);
        });
      });

      describe('renameColumn', function() {
        it('should rename a character without special characters', function() {
          var initialQuery = getMockBox().querySim('col1,col2
          1 | 1
          2 | 2');
          var columns = initialQuery.getColumnNames();
          var columnsLen = arrayLen(columns);
          var oldColumnName = columns[columnsLen];
          var newColumnName = columns[columnsLen] & '_test';
          var expectedColumns = columns;
          expectedColumns[columnsLen] = newColumnName;
          var queryUnderTest = util.renameColumn(
            query: initialQuery,
            oldName: oldColumnName,
            newName: newColumnName
          );

          expect(queryUnderTest)
            .toBeQuery()
            .notToBeEmpty();

          expect(queryUnderTest.getColumnNames())
            .toHaveLength(columnsLen)
            .toBeArray()
            .toBe(expectedColumns);
        });
      });

      describe('getColumnNames', function() {
        it('should return an array of column names without sorting them', function() {
          var query = getMockBox().querySim('col1,col3,col2
            1 | 2 | 3
            1 | 3 | 2');

          var columns = util.getColumnNames(query);

          expect(columns)
            .toHaveLength(3)
            .toBeArray();

          expect(columns[1]).toBe('col1');
          expect(columns[2]).toBe('col3');
          expect(columns[3]).toBe('col2');
        });
      });
    });
  }
}
