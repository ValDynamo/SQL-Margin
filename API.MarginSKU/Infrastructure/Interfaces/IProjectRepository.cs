using API.MarginSKU.Domain.Entities;
using Microsoft.Extensions.Hosting;

namespace API.MarginSKU.Infrastructure.Interfaces
{
    public interface IProjectRepository
    {
        public Task<IEnumerable<Project>> GetAllAsync();
    }
}
