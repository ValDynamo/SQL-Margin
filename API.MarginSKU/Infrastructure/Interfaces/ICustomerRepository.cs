using API.MarginSKU.Domain.Entities;
using Microsoft.Extensions.Hosting;

namespace API.MarginSKU.Infrastructure.Interfaces
{
    public interface ICustomerRepository
    {
        public Task<IEnumerable<Customer>> GetAllAsync();
    }
}
