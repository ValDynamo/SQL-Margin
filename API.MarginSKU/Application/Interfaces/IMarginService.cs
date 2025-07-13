using API.MarginSKU.Domain.Entities;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace API.MarginSKU.Application.Interfaces
{
    public interface IMarginService
    {
        Task<IEnumerable<Margin>> GetAllAsync(DateTime fromDate, DateTime toDate);
    }
}
