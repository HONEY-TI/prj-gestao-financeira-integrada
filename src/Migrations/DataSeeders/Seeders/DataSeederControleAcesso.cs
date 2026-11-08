using Infrastructure.DatabaseContexts;
using Domain.Core.ValueObject;
using Domain.Entities;
using EasyCryptoSalt;
using Migrations.DataSeeders.Abstractions;

namespace Migrations.DataSeeders.Seeders;

public class DataSeederAcesso : ISeeder
{
    private readonly ICrypto _crypto;
    private readonly RegisterContext _context;

    public DataSeederAcesso(RegisterContext context, ICrypto crypto)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
        _crypto = crypto ?? throw new ArgumentNullException(nameof(crypto));
    }

    public void Seed()
    {
        this.Insert();
    }

    private void Insert()
    {
        CreateAndSaveUser(
            nome: "Alex",
            sobrenome: "Ribeiro de Faria",
            telefone: "(21) 99287-9319",
            email: "alexfariakof@yahoo.com.br",
            senha: "toor",
            perfilId: 1
        );

        CreateAndSaveUser(
            nome: "Teste",
            sobrenome: "Teste",
            telefone: "(21) 9999-9999",
            email: "user@example.com",
            senha: "toor",
            perfilId: 2
        );
    }

    private void CreateAndSaveUser(
        string nome,
        string sobrenome,
        string telefone,
        string email,
        string senha,
        int perfilId)
    {
        var usuario = new Usuario
        {
            Nome = nome,
            SobreNome = sobrenome,
            Telefone = telefone,
            Email = email,
            StatusUsuario = StatusUsuario.Ativo
        };

        var acesso = new Acesso();
        acesso.CreateAccount(usuario, _crypto.Encrypt(senha));

        acesso.Usuario.PerfilUsuario = GetOrCreatePerfil(perfilId);
        acesso.Usuario.Categorias.ToList()
            .ForEach(c =>
            {
                c.UsuarioId = acesso.Usuario.Id;
                c.TipoCategoria = GetOrCreateTipoCategoria(c.TipoCategoria!.Id);
            });

        _context.Add(acesso);
        _context.SaveChanges();
    }

    private PerfilUsuario GetOrCreatePerfil(int perfilId)
    {
        var perfil = _context.PerfilUsuario.SingleOrDefault(p => p.Id == perfilId);
        if (perfil is not null)
            return perfil;

        if (!Enum.IsDefined(typeof(PerfilUsuario.Perfil), perfilId))
            throw new ArgumentOutOfRangeException(nameof(perfilId), perfilId, "Perfil de usuário inexistente.");

        perfil = new PerfilUsuario((PerfilUsuario.Perfil)perfilId);
        _context.PerfilUsuario.Add(perfil);
        _context.SaveChanges();

        return perfil;
    }

    private TipoCategoria GetOrCreateTipoCategoria(int tipoCategoriaId)
    {
        var tipoCategoria = _context.TipoCategoria
            .SingleOrDefault(tc => tc.Id == tipoCategoriaId);
        if (tipoCategoria is not null)
            return tipoCategoria;

        if (!Enum.IsDefined(typeof(TipoCategoria.CategoriaType), tipoCategoriaId)
            || tipoCategoriaId == (int)TipoCategoria.CategoriaType.Invalid)
            throw new ArgumentOutOfRangeException(
                nameof(tipoCategoriaId),
                tipoCategoriaId,
                "Tipo de categoria inexistente.");

        tipoCategoria = new TipoCategoria((TipoCategoria.CategoriaType)tipoCategoriaId);
        _context.TipoCategoria.Add(tipoCategoria);
        _context.SaveChanges();

        return tipoCategoria;
    }
}
