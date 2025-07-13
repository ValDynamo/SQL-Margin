using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;
using Dapper;
using System.Data;

namespace API.MarginSKU.Infrastructure.Data.Repositories
{
    public class GoodRepository : IGoodRepository
    {
        private IDbConnection _db;
        private DapperContext _dapperContext;

        public GoodRepository(DapperContext dapperContext)
        {
            _dapperContext = dapperContext;
            _db = _dapperContext.CreateConnection();
        }
        public async Task<IEnumerable<Good>> GetAllAsync()
        {
            string sql = $"SELECT * FROM Goods";

            return await _db.QueryAsync<Good>(sql);

        }
    }
}
