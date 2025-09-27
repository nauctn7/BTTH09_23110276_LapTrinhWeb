<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>Products</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3><i class="fas fa-box text-primary"></i> Quản lý Sản phẩm</h3>
    <button class="btn btn-secondary" onclick="window.location.href='/'">
      <i class="fas fa-arrow-left"></i> Quay lại trang chủ
    </button>
  </div>

  <!-- Form CRUD -->
  <div class="card mb-4">
    <div class="card-header">
      <h5 class="mb-0"><i class="fas fa-plus-circle"></i> Thêm/Sửa Sản phẩm</h5>
    </div>
    <div class="card-body">
      <form class="row g-2" onsubmit="return save()">
        <input type="hidden" id="id"/>
        <div class="col-md-3">
          <label class="form-label">Tên sản phẩm</label>
          <input id="title" class="form-control" placeholder="Nhập tên sản phẩm" required>
        </div>
        <div class="col-md-2">
          <label class="form-label">Số lượng</label>
          <input type="number" id="quantity" class="form-control" placeholder="Số lượng">
        </div>
        <div class="col-md-2">
          <label class="form-label">Giá</label>
          <input type="number" id="price" class="form-control" placeholder="Giá">
        </div>
        <div class="col-md-5">
          <label class="form-label">Mô tả</label>
          <input id="description" class="form-control" placeholder="Mô tả sản phẩm">
        </div>
        <div class="col-md-6">
          <label class="form-label">Hình ảnh </label>
          <div class="input-group">
            <input type="file" id="imageFile" class="form-control" accept="image/*" onchange="previewImage()">
            <button type="button" class="btn btn-outline-secondary" onclick="clearImage()">
              <i class="fas fa-times"></i>
            </button>
          </div>
          <input type="hidden" id="image" />
          <div id="imagePreview" class="mt-2" style="display: none;">
            <img id="previewImg" src="" alt="Preview" style="max-width: 200px; max-height: 150px;" class="img-thumbnail">
          </div>
        </div>
        <div class="col-md-3">
          <label class="form-label">Người dùng</label>
          <select id="userId" class="form-select" required></select>
        </div>
        <div class="col-md-3">
          <label class="form-label">Danh mục</label>
          <select id="categoryId" class="form-select" required></select>
        </div>
        <div class="col-md-2 d-grid">
          <label class="form-label">&nbsp;</label>
          <button class="btn btn-success">
            <i class="fas fa-save"></i> Lưu
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Filter theo Category -->
  <div class="card mb-4">
    <div class="card-header">
      <h5 class="mb-0"><i class="fas fa-filter"></i> Lọc và Hiển thị</h5>
    </div>
    <div class="card-body">
      <div class="row g-2">
        <div class="col-md-4">
          <label class="form-label">Lọc theo danh mục</label>
          <select id="filterCategory" class="form-select" onchange="load()">
            <option value="">-- Tất cả danh mục (sắp xếp theo giá tăng dần) --</option>
          </select>
        </div>
        <div class="col-md-2">
          <label class="form-label">&nbsp;</label>
          <button class="btn btn-primary d-block" onclick="load()">
            <i class="fas fa-sync-alt"></i> Làm mới
          </button>
        </div>
        <div class="col-md-6">
          <div class="alert alert-info mb-0">
            <i class="fas fa-info-circle"></i> 
            <strong>Chức năng:</strong> Hiển thị tất cả sản phẩm theo giá từ thấp đến cao, hoặc lọc theo danh mục
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Bảng hiển thị -->
  <div class="card">
    <div class="card-header">
      <h5 class="mb-0"><i class="fas fa-list"></i> Danh sách Sản phẩm</h5>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover mb-0">
          <thead class="table-light">
            <tr>
              <th>#</th>
              <th><i class="fas fa-image"></i> Hình ảnh</th>
              <th><i class="fas fa-tag"></i> Tên sản phẩm</th>
              <th><i class="fas fa-boxes"></i> Số lượng</th>
              <th><i class="fas fa-dollar-sign"></i> Giá</th>
              <th><i class="fas fa-folder"></i> Danh mục</th>
              <th><i class="fas fa-user"></i> Người dùng</th>
              <th><i class="fas fa-cogs"></i> Thao tác</th>
            </tr>
          </thead>
          <tbody id="rows"></tbody>
        </table>
      </div>
    </div>
  </div>

<script>
/* ===== Hàm gọi GraphQL ===== */
async function gql(query, variables = {}) {
  const res = await fetch('/graphql', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({query, variables})
  });
  const json = await res.json();
  if (json.errors) {
    const errorMessage = json.errors.map(e => e.message).join('\n');
    console.error('GraphQL errors:', json.errors);
    throw new Error(errorMessage);
  }
  return json.data || {};
}

/* ===== Query/Mutation ===== */
const Q_USERS = `query { users { id fullname } }`;
const Q_CATS  = `query { categories { id name } }`;
const Q_LIST_ASC = `query { productsSortedByPriceAsc {
    id title quantity price description image
    category { id name } user { id fullname }
  }}`;
const Q_BY_CAT = `query($cid:ID!){
  productsByCategory(categoryId:$cid){
    id title quantity price description image
    category { id name } user { id fullname }
  }
}`;
const C = `mutation($in:ProductInput!){ createProduct(input:$in){ id } }`;
const U = `mutation($id:ID!, $in:ProductInput!){ updateProduct(id:$id, input:$in){ id } }`;
const D = `mutation($id:ID!){ deleteProduct(id:$id) }`;

/* ===== Upload File Functions ===== */
async function uploadFile(file) {
  console.log('Uploading file:', file.name, file.size, file.type);
  
  const formData = new FormData();
  formData.append('file', file);
  
  try {
    const response = await fetch('/api/upload', {
      method: 'POST',
      body: formData
    });
    
    console.log('Upload response status:', response.status);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const result = await response.json();
    console.log('Upload result:', result);
    
    if (result.success) {
      console.log('Upload successful:', result.url);
      return result.url;
    } else {
      console.error('Upload failed:', result.message);
      alert('Lỗi upload: ' + result.message);
      return null;
    }
  } catch (error) {
    console.error('Upload error:', error);
    alert('Lỗi upload file: ' + error.message);
    return null;
  }
}

function previewImage() {
  const fileInput = document.getElementById('imageFile');
  const preview = document.getElementById('imagePreview');
  const previewImg = document.getElementById('previewImg');
  
  if (fileInput.files && fileInput.files[0]) {
    const reader = new FileReader();
    reader.onload = function(e) {
      previewImg.src = e.target.result;
      preview.style.display = 'block';
    };
    reader.readAsDataURL(fileInput.files[0]);
  }
}

function clearImage() {
  document.getElementById('imageFile').value = '';
  document.getElementById('image').value = '';
  document.getElementById('imagePreview').style.display = 'none';
}

/* ===== Load danh sách ===== */
async function initSelects(){
  const us = await gql(Q_USERS);
  const cs = await gql(Q_CATS);

  userId.innerHTML = '<option value="">-- User --</option>';
  (us.users||[]).forEach(u=> userId.innerHTML += `<option value="${u.id}">${u.fullname}</option>`);

  categoryId.innerHTML = '<option value="">-- Category --</option>';
  filterCategory.innerHTML = '<option value="">-- All categories (sorted by price asc) --</option>';
  (cs.categories||[]).forEach(c=>{
    categoryId.innerHTML   += `<option value="${c.id}">${c.name}</option>`;
    filterCategory.innerHTML+= `<option value="${c.id}">${c.name}</option>`;
  });
}

async function load(){
  const cid = filterCategory.value;
  const data = cid ? await gql(Q_BY_CAT,{cid}) : await gql(Q_LIST_ASC);
  const list = cid ? (data.productsByCategory||[]) : (data.productsSortedByPriceAsc||[]);

  rows.innerHTML = '';
  list.forEach((p,i)=>{
    const price = p.price ? new Intl.NumberFormat('vi-VN', { 
      style: 'currency', 
      currency: 'VND' 
    }).format(p.price) : '';
    
    const imageHtml = p.image ? 
      `<img src="${p.image}" alt="${p.title}" style="width: 50px; height: 50px; object-fit: cover;" class="img-thumbnail">` :
      `<i class="fas fa-image text-muted" style="font-size: 2rem;"></i>`;
    
    rows.innerHTML += `
      <tr>
        <td><span class="badge bg-secondary">${i+1}</span></td>
        <td>${imageHtml}</td>
        <td><strong>${p.title??''}</strong></td>
        <td><span class="badge bg-info">${p.quantity??0}</span></td>
        <td><span class="text-success fw-bold">${price}</span></td>
        <td><span class="badge bg-warning">${p.category?.name??''}</span></td>
        <td>${p.user?.fullname??''}</td>
        <td>
          <button class="btn btn-sm btn-primary me-1" onclick='edit(${JSON.stringify(p).replaceAll("'","\\'")})'>
            <i class="fas fa-edit"></i> Sửa
          </button>
          <button class="btn btn-sm btn-danger" onclick="removeP('${p.id}')">
            <i class="fas fa-trash"></i> Xóa
          </button>
        </td>
      </tr>`;
  });
}

function edit(p){
  id.value=p.id; title.value=p.title||''; quantity.value=p.quantity||''; price.value=p.price||'';
  description.value=p.description||''; userId.value=p.user?.id||''; categoryId.value=p.category?.id||'';
  
  // Xử lý hình ảnh
  if(p.image) {
    document.getElementById('image').value = p.image;
    document.getElementById('previewImg').src = p.image;
    document.getElementById('imagePreview').style.display = 'block';
  } else {
    clearImage();
  }
  
  window.scrollTo({top:0,behavior:'smooth'});
}

async function save(){
  console.log('Save function called');
  
  let imageUrl = document.getElementById('image').value;
  
  // Nếu có file mới được chọn, upload file
  const fileInput = document.getElementById('imageFile');
  if (fileInput.files && fileInput.files[0]) {
    console.log('Uploading file...');
    const uploadedUrl = await uploadFile(fileInput.files[0]);
    if (uploadedUrl) {
      imageUrl = uploadedUrl;
      console.log('File uploaded:', uploadedUrl);
    } else {
      console.log('Upload failed');
      return false; // Dừng nếu upload thất bại
    }
  }
  
  const inPayload={
    title:title.value.trim(),
    quantity: quantity.value?parseInt(quantity.value,10):null,
    description:description.value.trim(),
    price: price.value?parseFloat(price.value):null,
    image: imageUrl,
    userId: parseInt(userId.value),
    categoryId: parseInt(categoryId.value)
  };
  
  console.log('Saving product:', inPayload);
  
  // Validation
  if (!userId.value || !categoryId.value) {
    alert('Vui lòng chọn người dùng và danh mục');
    return false;
  }
  
  if (!title.value.trim()) {
    alert('Vui lòng nhập tên sản phẩm');
    return false;
  }
  
  try {
    if(id.value) {
      await gql(U,{id:id.value,in:inPayload});
      console.log('Product updated');
    } else {
      await gql(C,{in:inPayload});
      console.log('Product created');
    }
    
    // Reset form
    id.value=''; title.value=''; quantity.value=''; price.value=''; description.value='';
    userId.value=''; categoryId.value=''; clearImage();
    
    console.log('Reloading list...');
    await load();
    console.log('List reloaded');
  } catch (error) {
    console.error('Error saving product:', error);
    console.error('Error details:', error);
    
   
    if (error.message) {
      errorMessage += error.message;
    } else if (error.errors) {
      errorMessage += error.errors.map(e => e.message).join(', ');
    } else {
      errorMessage += JSON.stringify(error);
    }
    
    alert(errorMessage);
  }
  
  return false;
}

async function removeP(pid){ if(confirm('Delete?')){ await gql(D,{id:pid}); await load(); } }

initSelects().then(load);
</script>
</body>
</html>
