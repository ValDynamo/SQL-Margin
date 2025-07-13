using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;
using Dapper;
using System.Data;

namespace API.MarginSKU.Infrastructure.Data.Repositories
{
    public class CustomerRepository : ICustomerRepository
    {
        private IDbConnection _db;
        private DapperContext _dapperContext;

        public CustomerRepository(DapperContext dapperContext)
        {
            _dapperContext = dapperContext;
            _db = _dapperContext.CreateConnection();
        }
        public async Task<IEnumerable<Customer>> GetAllAsync()
        {
            string sql = $"SELECT * FROM Customers";

            return await _db.QueryAsync<Customer>(sql);

        }
    }
}
