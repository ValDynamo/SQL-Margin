using API.MarginSKU.Domain.Entities;
using Microsoft.Extensions.Hosting;

namespace API.MarginSKU.Infrastructure.Interfaces
{
    public interface IMarginRepository
    {
        public Task<IEnumerable<Margin>> GetAllAsync(DateTime fromDate, DateTime toDate);
    }
}
