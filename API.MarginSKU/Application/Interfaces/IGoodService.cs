using API.MarginSKU.Domain.Entities;
using Microsoft.AspNetCore.Mvc;

namespace API.MarginSKU.Application.Interfaces
{
    public interface IGoodService
    {
        Task<IEnumerable<Good>> GetAllAsync();
    }
}
