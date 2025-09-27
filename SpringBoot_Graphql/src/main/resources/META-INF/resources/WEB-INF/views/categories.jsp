<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>Categories</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3><i class="fas fa-tags text-warning"></i> Quản lý Danh mục</h3>
    <button class="btn btn-secondary" onclick="window.location.href='/'">
      <i class="fas fa-arrow-left"></i> Quay lại trang chủ
    </button>
  </div>

  <!-- Form -->
  <div class="card mb-4">
    <div class="card-header">
      <h5 class="mb-0"><i class="fas fa-plus-circle"></i> Thêm/Sửa Danh mục</h5>
    </div>
    <div class="card-body">
      <form class="row g-2" onsubmit="return saveCategory(event)">
        <input type="hidden" id="catId"/>
        <div class="col-md-4">
          <label class="form-label">Tên danh mục</label>
          <input id="catName" class="form-control" placeholder="Nhập tên danh mục" required>
        </div>
        <div class="col-md-4">
          <label class="form-label">Hình ảnh</label>
          <div class="input-group">
            <input type="file" id="catImageFile" class="form-control" accept="image/*" onchange="previewCategoryImage()">
            <button type="button" class="btn btn-outline-secondary" onclick="clearCategoryImage()">
              <i class="fas fa-times"></i>
            </button>
          </div>
          <input type="hidden" id="catImages" />
          <div id="catImagePreview" class="mt-2" style="display: none;">
            <img id="previewCatImg" src="" alt="Preview" style="max-width: 200px; max-height: 150px;" class="img-thumbnail">
          </div>
        </div>
        <div class="col-md-4 d-grid">
          <label class="form-label">&nbsp;</label>
          <button class="btn btn-success" type="submit">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Bảng hiển thị -->
  <div class="card">
    <div class="card-header">
      <h5 class="mb-0"><i class="fas fa-list"></i> Danh sách Danh mục</h5>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover mb-0">
          <thead class="table-light">
            <tr>
              <th>#</th>
              <th><i class="fas fa-tag"></i> Tên danh mục</th>
              <th><i class="fas fa-image"></i> Hình ảnh</th>
              <th><i class="fas fa-cogs"></i> Thao tác</th>
            </tr>
          </thead>
          <tbody id="rows"></tbody>
        </table>
      </div>
    </div>
  </div>

<script>
/* ===== Upload File Functions ===== */
async function uploadFile(file) {
  const formData = new FormData();
  formData.append('file', file);
  
  try {
    const response = await fetch('/api/upload', {
      method: 'POST',
      body: formData
    });
    const result = await response.json();
    
    if (result.success) {
      return result.url;
    } else {
      alert('Lỗi upload: ' + result.message);
      return null;
    }
  } catch (error) {
    alert('Lỗi upload file: ' + error.message);
    return null;
  }
}

function previewCategoryImage() {
  const fileInput = document.getElementById('catImageFile');
  const preview = document.getElementById('catImagePreview');
  const previewImg = document.getElementById('previewCatImg');
  
  if (fileInput.files && fileInput.files[0]) {
    const reader = new FileReader();
    reader.onload = function(e) {
      previewImg.src = e.target.result;
      preview.style.display = 'block';
    };
    reader.readAsDataURL(fileInput.files[0]);
  }
}

function clearCategoryImage() {
  document.getElementById('catImageFile').value = '';
  document.getElementById('catImages').value = '';
  document.getElementById('catImagePreview').style.display = 'none';
}

async function gql(query, variables = {}) {
  const res = await fetch('/graphql', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ query, variables })
  });
  let json;
  try { json = await res.json(); } catch(e) {
    alert('Không đọc được JSON từ /graphql'); return {};
  }
  if (json.errors) {
    alert(json.errors.map(e => e.message).join('\n'));
  }
  return json.data || {};
}

/* GraphQL */
const Q = `query { categories { id name images } }`;
const C = `mutation($input:CategoryInput!){
  createCategory(input:$input){ id name images }
}`;
const U = `mutation($id:ID!, $input:CategoryInput!){
  updateCategory(id:$id, input:$input){ id name images }
}`;
const D = `mutation($id:ID!){ deleteCategory(id:$id) }`;

/* Load list */
async function loadCategories(){
  const d = await gql(Q);
  const list = d.categories || [];
  const tb = document.getElementById('rows');
  tb.innerHTML = '';
  list.forEach((c,i)=>{
    const imageHtml = c.images ? 
      `<img src="${c.images}" alt="${c.name}" style="width: 50px; height: 50px; object-fit: cover;" class="img-thumbnail">` :
      `<i class="fas fa-image text-muted" style="font-size: 2rem;"></i>`;
    
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td><span class="badge bg-secondary">${i+1}</span></td>
      <td><strong>${c.name ?? ''}</strong></td>
      <td>${imageHtml}</td>
      <td>
        <button class="btn btn-sm btn-primary me-1"
                onclick='editCategory(${JSON.stringify(c).replaceAll("'","\\'")})'>
          <i class="fas fa-edit"></i> Sửa
        </button>
        <button class="btn btn-sm btn-danger"
                onclick="removeCategory('${c.id}')">
          <i class="fas fa-trash"></i> Xóa
        </button>
      </td>`;
    tb.appendChild(tr);
  });
}

/* Edit -> fill form */
function editCategory(c){
  document.getElementById('catId').value = c.id;
  document.getElementById('catName').value = c.name || '';
  document.getElementById('catImages').value = c.images || '';
  
  // Xử lý hình ảnh
  if(c.images) {
    document.getElementById('previewCatImg').src = c.images;
    document.getElementById('catImagePreview').style.display = 'block';
  } else {
    clearCategoryImage();
  }
  
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

/* Save (create/update) */
async function saveCategory(e){
  if (e) e.preventDefault(); // stop default submit

  const idEl = document.getElementById('catId');
  const nameEl = document.getElementById('catName');
  const imagesEl = document.getElementById('catImages');

  let imageUrl = imagesEl.value;
  
  // Nếu có file mới được chọn, upload file
  const fileInput = document.getElementById('catImageFile');
  if (fileInput.files && fileInput.files[0]) {
    const uploadedUrl = await uploadFile(fileInput.files[0]);
    if (uploadedUrl) {
      imageUrl = uploadedUrl;
    } else {
      return false; // Dừng nếu upload thất bại
    }
  }

  const input = {
    name: (nameEl.value || '').trim(),
    images: imageUrl
  };
  if (!input.name) { alert('Tên danh mục là bắt buộc'); return false; }

  if (idEl.value) {
    await gql(U, { id: idEl.value, input });    // variables.input
  } else {
    await gql(C, { input });                     // variables.input
  }

  // reset form + reload
  idEl.value = '';
  nameEl.value = '';
  imagesEl.value = '';
  clearCategoryImage();
  await loadCategories();
  return false; // also block page reload
}

/* Delete */
async function removeCategory(id){
  if (!confirm('Delete?')) return;
  await gql(D, { id });
  await loadCategories();
}

loadCategories();
</script>
</body>
</html>
