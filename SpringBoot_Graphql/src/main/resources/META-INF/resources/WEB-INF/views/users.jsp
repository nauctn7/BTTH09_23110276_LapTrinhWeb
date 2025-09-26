<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html><html><head>
<title>Users</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head><body class="p-4">
<h3>Users</h3>
 <!-- Nút quay lại -->
  <div class="mb-3">
    <button class="btn btn-secondary" onclick="window.location.href='/'">← Quay lại trang chủ</button>
  </div>
<form class="row g-2 mb-3" onsubmit="return save()">
  <input type="hidden" id="id"/>
  <div class="col-md-3"><input id="fullname" class="form-control" placeholder="Full name" required></div>
  <div class="col-md-3"><input id="email" class="form-control" placeholder="Email" required></div>
  <div class="col-md-2"><input id="password" class="form-control" placeholder="Password" required></div>
  <div class="col-md-2"><input id="phone" class="form-control" placeholder="Phone"></div>
  <div class="col-md-2 d-grid"><button class="btn btn-success">Save</button></div>
</form>

<table class="table table-hover">
  <thead><tr><th>#</th><th>Fullname</th><th>Email</th><th>Phone</th><th>Actions</th></tr></thead>
  <tbody id="rows"></tbody>
</table>

<script>
async function gql(q,v={}){const r=await fetch('/graphql',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({query:q,variables:v})});const j=await r.json();if(j.errors)alert(j.errors.map(e=>e.message).join('\n'));return j.data||{};}
const Q=`query{ users{ id fullname email phone } }`;
const C=`mutation($in:UserInput!){ createUser(input:$in){ id } }`;
const U=`mutation($id:ID!,$in:UserInput!){ updateUser(id:$id,input:$in){ id } }`;
const D=`mutation($id:ID!){ deleteUser(id:$id) }`;

async function load(){const d=await gql(Q);rows.innerHTML='';(d.users||[]).forEach((u,i)=>{rows.innerHTML+=`
<tr><td>${i+1}</td><td>${u.fullname??''}</td><td>${u.email??''}</td><td>${u.phone??''}</td>
<td><button class="btn btn-sm btn-primary me-1" onclick='edit(${JSON.stringify(u).replaceAll("'","\\'")})'>Edit</button>
<button class="btn btn-sm btn-danger" onclick="rem('${u.id}')">Delete</button></td></tr>`});}
function edit(u){id.value=u.id;fullname.value=u.fullname||'';email.value=u.email||'';password.value='';phone.value=u.phone||'';}
async function save(){const inP={fullname:fullname.value.trim(),email:email.value.trim(),password:(password.value.trim()||'123456'),phone:phone.value.trim()}; if(id.value)await gql(U,{id:id.value,in:inP}); else await gql(C,{in:inP}); id.value='';fullname.value='';email.value='';password.value='';phone.value='';await load();return false;}
async function rem(idv){ if(confirm('Delete?')){ await gql(D,{id:idv}); await load(); } }
load();
</script>
</body></html>
