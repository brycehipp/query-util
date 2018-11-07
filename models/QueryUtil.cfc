component {

  /**
     * Creates a new query that excludes the rows starting at `start` and ending at `start + count`.
     *
     * @query Query to splice
     * @start Row to being the splice
     * @count Count of record to splice after the starting row. if 0, no rows will be spliced
     */
    public query function splice(required query query, required numeric start, numeric count = 1) {
      // Go ahead and return the query if theres nothing to splice
      if (!val(count)) return query;

      var columns = getColumnNames(query);
      var newQuery = queryNew(arrayToList(columns));
      var recordCount = query.recordCount;
      var startOffset = count - 1;

      // Return empty if we are starting at the query's record count or higher
      if (start >= recordCount) return newQuery;

      for (var row = 1; row <= recordCount; row++) {
        if (row < start || row > start + startOffset) {
          queryAddRow(newQuery, 1);
          for (var column in columns) {
            querySetCell(newQuery, column, query[column][row]);
          }
        }
      }

      return newQuery;
    }

    /**
     * Creates a new query that is a subset of rows starting at `begin` and ending at `end`.
     * Note: `slice` will extract up to but not including `end`
     *
     * @query Query to slice
     * @begin Row to begin the slice
     * @end Row before which to end the slice
     */
    public query function slice(required query query, required numeric begin, numeric end = 0) {
      var recordCount = query.recordCount;

      // If the whole query is being asked for, just return it
      if (begin == 1 && end == recordCount + 1) return query;

      var columns = getColumnNames(query);
      var newQuery = queryNew(arrayToList(columns));

      // If end is anything more than recordCount, its the same as recordCount + 1
      // We always want to return the rest of the query
      if (end > recordCount) {
        end = recordCount + 1;
      }

      if (begin >= recordCount) return newQuery;

      if (!val(end)) {
        end = recordCount + 1;
      }

      if (end == 1){
        end++;
      }

      for (var row = 1; row <= recordCount; row++) {
        if (row >= begin && row < end) {
          queryAddRow(newQuery, 1);
          for (var column in columns) {
            querySetCell(newQuery, column, query[column][row]);
          }
        }
      }

      return newQuery;
    }

    /**
     * Update the name of a query's column. This will return the provided query with the new column name.
     *
     * @query Query to alter the column name of
     * @oldName The old column name
     * @newName The new column name
     */
    public query function renameColumn(required query query, required string oldName, required string newName) {
      var columns = getColumnNames(query);
      var newNames = [];

      for (var column in columns) {
        var name = lCase(column) == lCase(oldName) ? newName : column;
        arrayAppend(newNames, name);
      }

      query.setColumnNames(newNames);

      return query;
    }

  /**
   * Return the column names of the query in the order in which they appear in the query.
   *
   * Note: This is an alternative to the undocumented function `query.getColumnNames()`.
   *
   * @query Query to get the column names of
   */
  public array function getColumnNames(required query query) {
    var metaData = getMetadata(query);

    var columnNames = [];

    for (var column in metaData) {
      arrayAppend(columnNames, column.name);
    }

    return columnNames;
  }
}
