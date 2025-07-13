using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;
using Dapper;
using System.Data;

namespace API.MarginSKU.Infrastructure.Data.Repositories
{
    public class MarginRepository : IMarginRepository
    {
        private IDbConnection _db;
        private DapperContext _dapperContext;

        public MarginRepository(DapperContext dapperContext)
        {

            _dapperContext = dapperContext;
            _db = _dapperContext.CreateConnection();
        }
        public async Task<IEnumerable<Margin>> GetAllAsync(DateTime fromDate, DateTime toDate)
        {
            var sql = @"SELECT * FROM MarginSKU WHERE Date >= @FromDate AND Date <= @ToDate";
            return await _db.QueryAsync<Margin>(sql, new { FromDate = fromDate, ToDate = toDate });
        }
    }
}
