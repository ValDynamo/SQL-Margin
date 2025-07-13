using API.MarginSKU.Domain.Entities;
using Microsoft.Extensions.Hosting;

namespace API.MarginSKU.Infrastructure.Interfaces
{
    public interface IGoodRepository
    {
        public Task<IEnumerable<Good>> GetAllAsync();
    }
}
