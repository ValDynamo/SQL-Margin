using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;
using Dapper;
using System.Data;

namespace API.MarginSKU.Infrastructure.Data.Repositories
{
    public class ProjectRepository : IProjectRepository
    {
        private IDbConnection _db;
        private DapperContext _dapperContext;

        public ProjectRepository(DapperContext dapperContext)
        {
            _dapperContext = dapperContext;
            _db = _dapperContext.CreateConnection();
        }
        public async Task<IEnumerable<Project>> GetAllAsync()
        {
            string sql = $"SELECT * FROM Projects";

            return await _db.QueryAsync<Project>(sql);

        }
    }
}
