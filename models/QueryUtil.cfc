component {

  /**
     * Creates a new query that excludes the rows starting at `start` and ending at `start + count`.
     *
     * @query Query to splice
     * @start Row to being the splice
     * @count Count of record to splice after the starting row. if 0, no rows will be spliced
     */
    public query function splice(required query query, required numeric start, numeric count = 1) {
      var columns = arguments.query.getColumnList();
      var newQuery = queryNew(arrayToList(columns));
      var recordCount = arguments.query.recordCount;
      var startOffset = arguments.count - 1;

      if (arguments.start >= recordCount) {
        return newQuery;
      }

      if (!val(arguments.count)) {
        return arguments.query;
      }

      for (var row = 1; row <= recordCount; row++) {
        if (row < arguments.start || row > arguments.start + startOffset) {
          queryAddRow(newQuery, 1);
          for (var column in columns) {
            querySetCell(newQuery, column, arguments.query[column][row]);
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
      var columns = arguments.query.getColumnList();
      var newQuery = queryNew(arrayToList(columns));
      var recordCount = arguments.query.recordCount;

      // If end is anything more than recordCount, its the same as recordCount + 1
      // We always want to return the rest of the query
      if (arguments.end > recordCount) {
        arguments.end = recordCount + 1;
      }

      // If the whole query is being asked for, just return it
      if (arguments.begin == 1 && arguments.end == recordCount + 1) {
        return arguments.query;
      }

      if (arguments.begin >= recordCount) {
        return newQuery;
      }

      if (!val(arguments.end)) {
        arguments.end = recordCount + 1;
      }
      if (arguments.end == 1){
        arguments.end++;
      }

      for (var row = 1; row <= recordCount; row++) {
        if (row >= arguments.begin && row < arguments.end) {
          queryAddRow(newQuery, 1);
          for (var column in columns) {
            querySetCell(newQuery, column, arguments.query[column][row]);
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
      var columns = getColumnNames(arguments.query);

      for (var i = 1; i <= arrayLen(columns); i++) {
        if (lCase(columns[i]) == lCase(arguments.oldName)) {
          columns[i] = arguments.newName;
        }
      }

      arguments.query.setColumnNames(columns);

      return arguments.query;
    }

  /**
   * Return the column names of the query in the order in which they appear in the query.
   *
   * Note: This is an alternative to the undocumented function `query.getColumnNames()`.
   *
   * @query Query to get the column names of
   */
  public array function getColumnNames(required query query) {
    var metaData = getMetadata(arguments.query);

    var columnNames = [];

    for (var column in metaData) {
      arrayAppend(columnNames, column.name);
    }

    return columnNames;
  }
}
