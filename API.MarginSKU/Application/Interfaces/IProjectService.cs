using API.MarginSKU.Domain.Entities;
using Microsoft.AspNetCore.Mvc;

namespace API.MarginSKU.Application.Interfaces
{
    public interface IProjectService
    {
        Task<IEnumerable<Project>> GetAllAsync();
    }
}
